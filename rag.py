import json
import os

from langchain.chat_models.gigachat import GigaChat
from langchain.schema import AIMessage, Document, HumanMessage, SystemMessage
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.embeddings import GigaChatEmbeddings
from langchain_community.vectorstores import Chroma

from utils import make_dirs


class Chat:
    def __init__(self) -> None:
        self.chroma_db = None
        self.dev = False
        self.llm = GigaChat(credentials=os.getenv('sber_auth'),
                            verify_ssl_certs=False,
                            scope="GIGACHAT_API_CORP")
        self.embeddings = GigaChatEmbeddings(credentials=os.getenv('sber_auth'),
                                             verify_ssl_certs=False,
                                             scope="GIGACHAT_API_CORP")
        self.prj_dir = os.getenv("data_path")
        self.persist_directory = os.path.join(self.prj_dir, "data")
        make_dirs(self.persist_directory)


class BaseLLM(Chat):
    def __init__(self, document_base: str, name_db) -> None:
        super().__init__()
        self.all_chunks = []        
        self.document_base = document_base
        self.json_data = None
        self.name_db = name_db

    @staticmethod
    def load_json_file(filename: str) -> list[Document]:
        with open(filename) as json_data:
            print('load')
            docs = json.load(json_data)
            json_data.close()        

        list_docs = []
        for doc in docs:
            text = doc.pop('text')
            langchain_doc = Document(text, metadata=doc)
            list_docs.append(langchain_doc)
        return list_docs

    def load_product_base(self) -> None:
        print('load json')
        load_json = self.load_json_file(self.document_base)
        self.json_data = load_json

        separators = [
                "\n\n",
                "\n",
                ".",
                " ",
                "",
            ]

        text_splitter = RecursiveCharacterTextSplitter(chunk_size=700,
                                                       add_start_index=True,
                                                       separators=separators)
        self.all_chunks = text_splitter.split_documents(load_json)

    def generate_embeddings(self) -> None:
        self.load_product_base()
        chunks = []        
        count = 0
        all_count = 0
        print(f"Чанков {len(self.all_chunks)}. Всего обработано: ", end='')
        for chunk in self.all_chunks:
            all_count = all_count + 1
            count = count + 1
            chunks.append(chunk)
            if count == 100:
                self.save_embeddings(chunks)
                chunks = []                
                count = 0
                print(f"{all_count}, ", end='')

        if len(chunks) > 0:
            self.save_embeddings(chunks)
        print('!')

    def save_embeddings(self, chunks: list[Document]) -> None:
        self.chroma_db = Chroma.from_documents(
            chunks,
            self.embeddings,
            persist_directory=self.persist_directory,
            collection_name=self.name_db)
        self.chroma_db.persist()


class DocumentManager(Chat):
    def __init__(self, json_filename: str):
        super().__init__()
        self.json_filename = json_filename

        base_name = os.path.basename(json_filename).split('.')[0]
        self.base_name = base_name

        self.load_base()
        self.messages = []
        self.role_system = "Ты научный сотрудник. Твоя задача отвечать на вопросы по контексту. "

    def load_base(self):
        self.chroma_db = Chroma(persist_directory=self.persist_directory, embedding_function=self.embeddings,
                                collection_name=self.base_name)

        collection = self.chroma_db.get()
        if self.dev:
            print(f"Всего в базе: {len(collection['ids'])}")

        if len(collection['ids']) == 0:
            admin = BaseLLM(self.json_filename, self.base_name)
            self.admin = admin
            admin.generate_embeddings()

    def find_examples(self, message: str) -> str:
        # Поиск релевантных отрезков из базы знаний
        message_en = self.translate_to_en(message)
        docs = self.chroma_db.similarity_search(message_en, k=4)

        db_messages = ""
        for i, doc in enumerate(docs):
            db_messages = db_messages + f"Документ №{i + 1}\n{doc.page_content}\n"

        if self.dev:
            print('db_messages:\n', db_messages)

        return db_messages

    def translate_to_en(self, text: str) -> str:
        msgs = [SystemMessage(content=f'Ты являешься специалистом по переводу текста твоя задача переводить текст с Русского на Английский. \
            Переведи следующий текст на английский: {text}\n \
            Перевод: ')]
        answer = self.llm(msgs)
        print('to_en:', answer.content)
        return answer.content

    def send_message(self, question: str, new_dialog: bool = False) -> str:
        if new_dialog:
            self.messages.clear()

        if len(self.messages) == 0:
            examples = self.find_examples(question)
            self.messages.append(SystemMessage(content=f"{self.role_system} Контекст: ${examples}\nОтвечай только на русском."))

        self.messages.append(HumanMessage(content=question))
        res = self.llm(self.messages)

        answer = res.content

        self.messages.append(AIMessage(content=answer))

        return answer
