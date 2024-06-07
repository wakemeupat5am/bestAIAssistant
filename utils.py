import os
import string


def make_dirs(path:str):
    try:
        os.makedirs(path)
    except OSError:
        pass
    else:
        print ("Успешно создана директория %s " % path)

def preprocess_text(text):
    # Убираем знаки препинания
    translator = str.maketrans('', '', string.punctuation)
    text = text.translate(translator)
    # Убираем пробелы
    text = text.replace(" ", "")
    return text