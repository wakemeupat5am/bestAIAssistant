from dotenv import load_dotenv

from rag import DocumentManager

load_dotenv()

agent_qa = DocumentManager('example/minecraft_data.json')

q = 'как уменьшить тревогу в игре майнркафт?'
print(agent_qa.find_examples(q))

answer = agent_qa.send_message(q, new_dialog=True)
print('answer 1:', answer)

q = 'А что ты еще узнал нового из документов minecraft?'

answer = agent_qa.send_message(q, new_dialog=False)
print('answer 2:', answer)

q = 'Каким образом это может снизить тревогу у детей?'

answer = agent_qa.send_message(q, new_dialog=False)
print('answer 3:', answer)
