import asyncio
import json
import logging
import os
import secrets
import string
import sys

from aiogram import Bot, Dispatcher, F, types
from aiogram.filters import CommandStart

# Настройка логирования
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

CFG_FILE = "cfg.txt"
DB_FILE = "data/db.json"

def load_config():
    """Загружает конфигурацию из файла cfg.txt."""
    if not os.path.exists(CFG_FILE):
        logger.error(f"Файл {CFG_FILE} не найден. Пожалуйста, создайте его.")
        sys.exit(1)
        
    config = {}
    with open(CFG_FILE, "r", encoding="utf-8") as f:
        for line in f:
            if '=' in line:
                key, val = line.strip().split('=', 1)
                config[key] = val
    return config

# Загрузка настроек
cfg = load_config()
BOT_TOKEN = cfg.get("BOT_TOKEN", "").strip()
try:
    ADMIN_ID = int(cfg.get("ADMIN_ID", "0").strip())
except ValueError:
    logger.error("ADMIN_ID в cfg.txt должен быть числом.")
    sys.exit(1)

# Инициализация бота и диспетчера
bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

def load_db():
    if not os.path.exists(DB_FILE):
        return {}
    with open(DB_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def save_db(data):
    os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)
    with open(DB_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

def generate_token(length=12):
    chars = string.ascii_letters + string.digits
    return ''.join(secrets.choice(chars) for _ in range(length))

@dp.message(CommandStart())
async def handle_start(message: types.Message):
    command_args = message.text.split(maxsplit=1)
    
    # Если передан аргумент (токен)
    if len(command_args) > 1:
        token = command_args[1]
        db = load_db()
        
        if token in db:
            file_info = db[token]
            file_id = file_info["file_id"]
            file_type = file_info["type"]
            custom_name = file_info["custom_name"]
            
            caption_text = f"📁 <b>Файл:</b> {custom_name}"
            
            try:
                # Пересылаем файл пользователю по file_id, не скачивая на ПК
                if file_type == "document":
                    await message.answer_document(document=file_id, caption=caption_text, parse_mode="HTML")
                elif file_type == "photo":
                    await message.answer_photo(photo=file_id, caption=caption_text, parse_mode="HTML")
                elif file_type == "video":
                    await message.answer_video(video=file_id, caption=caption_text, parse_mode="HTML")
                elif file_type == "audio":
                    await message.answer_audio(audio=file_id, caption=caption_text, parse_mode="HTML")
            except Exception as e:
                logger.error(f"Ошибка при отправке файла: {e}")
                await message.answer("❌ Произошла ошибка при отправке файла.")
        else:
            await message.answer("❌ Ошибка: Неверный или недействительный токен.")
    else:
        # Обычный старт
        if message.from_user.id == ADMIN_ID:
            await message.answer(
                "👋 Привет, Админ!\n\n"
                "Отправь мне любой файл и <b>ОБЯЗАТЕЛЬНО добавь текст в «Подпись» (Caption)</b> — этот текст станет именем файла.\n"
                "Я сохраню только file_id файла в базе без сохранения на ваш ПК.",
                parse_mode="HTML"
            )
        else:
            await message.answer("👋 Привет! Я бот-хранилище файлов.\n\nПерейдите по специальной ссылке-приглашению, чтобы получить файл.")

@dp.message(F.document | F.photo | F.video | F.audio)
async def handle_file_upload(message: types.Message):
    """Обработчик файлов (только для админа)."""
    if message.from_user.id != ADMIN_ID:
        await message.answer("⛔️ У вас нет прав для загрузки файлов.")
        return

    # Требуем, чтобы админ указал имя в подписи к файлу
    custom_name = message.caption
    if not custom_name:
        await message.answer(
            "❌ Ошибка: Вы не указали имя файла!\n\n"
            "Пожалуйста, отправьте файл заново и <b>напишите желаемое имя в поле «Подпись» (добавить подпись...)</b>.",
            parse_mode="HTML"
        )
        return

    file_id = None
    file_type = None
    
    # Получаем file_id
    if message.document:
        file_id = message.document.file_id
        file_type = "document"
    elif message.photo:
        file_id = message.photo[-1].file_id # фото в лучшем качестве
        file_type = "photo"
    elif message.video:
        file_id = message.video.file_id
        file_type = "video"
    elif message.audio:
        file_id = message.audio.file_id
        file_type = "audio"

    if not file_id:
        await message.answer("❌ Не удалось получить ID файла.")
        return

    try:
        token = generate_token()
        
        # Сохраняем в БД только file_id и кастомное имя
        db = load_db()
        db[token] = {
            "file_id": file_id,
            "type": file_type,
            "custom_name": custom_name,
            "owner_id": message.from_user.id
        }
        save_db(db)

        # Ссылка
        bot_info = await bot.get_me()
        link = f"https://t.me/{bot_info.username}?start={token}"
        
        await message.answer(
            f"✅ <b>Файл успешно добавлен в базу! (Без сохранения на ПК)</b>\n\n"
            f"Имя: <code>{custom_name}</code>\n"
            f"Токен: <code>{token}</code>\n\n"
            f"🔗 Уникальная ссылка:\n{link}",
            parse_mode="HTML"
        )
    except Exception as e:
        logger.error(f"Ошибка сохранения в БД: {e}")
        await message.answer("❌ Произошла ошибка. Проверьте логи.")

async def main():
    os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)
    
    if not BOT_TOKEN or BOT_TOKEN == "your_bot_token_here":
        logger.error("Пожалуйста, укажите настоящий BOT_TOKEN в файле cfg.txt")
        return
        
    logger.info("Бот запускается... (Режим облачного пересылания без сохранения на ПК)")
    await bot.delete_webhook(drop_pending_updates=True)
    await dp.start_polling(bot)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except (KeyboardInterrupt, SystemExit):
        logger.info("Бот остановлен.")
