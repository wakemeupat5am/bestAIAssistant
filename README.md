Решение команды ГАМК

# DEEPHACK.AGENTS

Разработай собственного ИИ-ассистента для науки на базе GigaChain

Решение:

## Лучший научный ассистент



Функционал:

### **Агент диалога вопросно-ответной системы по статьям с сайта researchgate.net Парсинг+RAG (система вопрос ответов по выбранной научной тематике)**



**Команда:**

Габиден Сагинтай (python backend)

Михаил Утробин (Data science)

Арсений Кульбако (Dart Flutter frontend)



### Для запуска необходимо:

1)  Отредактировать .env файл с переменными окружения

   1) Заполнить переменную окружения sber_auth - токен GigaChat
   2) Заполнить переменную окружения data_path - путь к создаваемой базе данных chroma db

2) Установить библиотеки

   ```bash
   pip install -r requirements.txt
   ```

   

3) Запуск полного примера (парсинг + RAG система)

   ```bash
   python parse_example.py
   ```

4. Запуск примера с диалогом по уже загруженным документам с сайта researchgate.net

   
    ```
    python rag_example.py
    ```
