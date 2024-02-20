# ffmpeg_installer

Инсталлятор FFmpeg для Windows.

## Скачать

- [Тут](https://github.com/SeryiBaran/ffmpeg_installer/releases/latest/download/sb_ffmpeg_setup.exe)

## Сборка

- Установите NSIS и добавьте папку с NSIS в PATH
- Распакуйте свежий билд FFmpeg для Windows в `src`
- Выполните:

  ```bash
  cd src && makensis setup.nsi
  ```
