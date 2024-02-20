# ffmpeg_installer

Инсталлятор FFmpeg для Windows.

## Сборка

- Установите NSIS добавьте папку с NSIS в PATH
- Распакуйте свежий билд FFmpeg для Windows в `src`
- Выполните:

  ```bash
  cd src && makensis setup.nsi
  ```
