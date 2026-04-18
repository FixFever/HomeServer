#!/usr/bin/env python3
"""
Скрипт для миграции файлов между альбомами в Immich

Использование:
    # Объединение дубликатов альбома (если есть несколько альбомов с одинаковым именем)
    python immich_migrate_albums.py --url http://localhost:2283 --api-key YOUR_API_KEY --target "Альбом"
    
    # Миграция файлов из указанных альбомов в целевой
    python immich_migrate_albums.py --url http://localhost:2283 --api-key YOUR_API_KEY --target "Конечный альбом" --sources "Альбом1" "Альбом2" "Альбом3"

Или с переменными окружения:
    export IMMICH_URL=http://localhost:2283
    export IMMICH_API_KEY=your_api_key
    python immich_migrate_albums.py --target "Альбом"
"""

import requests
import argparse
import os
import sys
import time
from typing import List, Optional
from urllib.parse import urljoin


class ImmichAlbumMigrator:
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.headers = {
            'x-api-key': api_key,
            'Content-Type': 'application/json'
        }
        self.session = requests.Session()
        self.session.headers.update(self.headers)

    def get_albums(self) -> List[dict]:
        """Получение списка всех альбомов"""
        response = self.session.get(urljoin(self.base_url, 'api/albums'))
        if response.status_code == 200:
            return response.json()
        return []

    def get_album_by_name(self, name: str) -> Optional[dict]:
        """Поиск альбома по точному имени"""
        albums = self.get_albums()
        for album in albums:
            if album.get('albumName') == name:
                return album
        return None

    def get_albums_by_name(self, name: str) -> List[dict]:
        """Поиск всех альбомов с заданным именем"""
        albums = self.get_albums()
        return [a for a in albums if a.get('albumName') == name]

    def create_album(self, name: str) -> dict:
        """Создание нового альбома"""
        print(f"  Создаю альбом '{name}'...")
        payload = {'albumName': name}
        response = self.session.post(
            urljoin(self.base_url, 'api/albums'),
            json=payload
        )
        if response.status_code in (200, 201):
            return response.json()
        raise Exception(f"Не удалось создать альбом: {response.text}")

    def get_album_assets(self, album_id: str) -> List[str]:
        """Получение списка ID всех файлов в альбоме"""
        response = self.session.get(urljoin(self.base_url, f'api/albums/{album_id}'))
        if response.status_code == 200:
            album_data = response.json()
            return [asset['id'] for asset in album_data.get('assets', []) if 'id' in asset]
        return []

    def add_assets_to_album(self, album_id: str, asset_ids: List[str]) -> None:
        """Добавление файлов в альбом"""
        if not asset_ids:
            return
        
        print(f"  Добавляю {len(asset_ids)} файлов...")
        payload = {'ids': asset_ids}
        
        response = self.session.put(
            urljoin(self.base_url, f'api/albums/{album_id}/assets'),
            json=payload
        )
        
        if response.status_code not in (200, 204):
            raise Exception(f"Не удалось добавить файлы: {response.text}")

    def delete_album(self, album_id: str) -> None:
        """Удаление альбома"""
        response = self.session.delete(urljoin(self.base_url, f'api/albums/{album_id}'))
        
        if response.status_code not in (200, 204):
            print(f"  Предупреждение: не удалось удалить альбом ({response.status_code})")

    def merge_duplicate_albums(self, album_name: str) -> None:
        """Объединение всех альбомов с одинаковым именем в один"""
        albums = self.get_albums_by_name(album_name)
        
        if len(albums) <= 1:
            print(f"\nАльбомов с именем '{album_name}' нет или он единственный. Объединение не требуется.")
            return
        
        print(f"\nНайдено {len(albums)} альбомов с именем '{album_name}':")
        for i, album in enumerate(albums, 1):
            asset_count = len(self.get_album_assets(album['id']))
            print(f"  {i}. ID: {album['id']}, файлов: {asset_count}")
        
        target_album = albums[0]
        print(f"\nОставляю первый альбом (ID: {target_album['id']}) как основной")
        
        for duplicate in albums[1:]:
            print(f"\nОбрабатываю альбом-дубликат (ID: {duplicate['id']})")
            asset_ids = self.get_album_assets(duplicate['id'])
            
            if asset_ids:
                print(f"  Найдено {len(asset_ids)} файлов для перемещения")
                self.add_assets_to_album(target_album['id'], asset_ids)
                time.sleep(0.5)
            else:
                print(f"  В альбоме нет файлов")
            
            self.delete_album(duplicate['id'])
        
        print(f"\nОбъединение завершено. В целевом альбоме теперь {len(self.get_album_assets(target_album['id']))} файлов.")

    def migrate_albums(self, target_name: str, source_names: List[str]) -> None:
        """Миграция файлов из исходных альбомов в целевой"""
        # Проверяем, есть ли целевой альбом
        target_album = self.get_album_by_name(target_name)
        
        if not target_album:
            print(f"\nЦелевой альбом '{target_name}' не найден, создаю новый...")
            target_album = self.create_album(target_name)
        else:
            print(f"\nЦелевой альбом '{target_name}' найден (ID: {target_album['id']})")
        
        # Переносим файлы из каждого исходного альбома
        for source_name in source_names:
            print(f"\nОбработка исходного альбома: '{source_name}'")
            
            source_album = self.get_album_by_name(source_name)
            
            if not source_album:
                print(f"  Предупреждение: Альбом '{source_name}' не найден, пропускаю")
                continue
            
            print(f"  Найден альбом (ID: {source_album['id']})")
            
            asset_ids = self.get_album_assets(source_album['id'])
            
            if not asset_ids:
                print(f"  В альбоме нет файлов")
            else:
                print(f"  Найдено {len(asset_ids)} файлов для перемещения")
                self.add_assets_to_album(target_album['id'], asset_ids)
                time.sleep(0.5)
            
            self.delete_album(source_album['id'])

    def run_migration(self, target_name: str, source_names: Optional[List[str]] = None) -> None:
        """Запуск процесса миграции"""
        print("=" * 60)
        print("МИГРАЦИЯ АЛЬБОМОВ IMMICH")
        print("=" * 60)
        
        if not source_names:
            # Режим объединения дубликатов
            print(f"Режим: объединение альбомов с именем '{target_name}'")
            print("=" * 60)
            self.merge_duplicate_albums(target_name)
        else:
            # Режим миграции
            print(f"Целевой альбом: {target_name}")
            print(f"Исходные альбомы: {', '.join(source_names)}")
            print("=" * 60)
            self.migrate_albums(target_name, source_names)
        
        print("\n" + "=" * 60)
        print("ОПЕРАЦИЯ ЗАВЕРШЕНА")
        print("=" * 60)


def main():
    parser = argparse.ArgumentParser(
        description='Миграция файлов между альбомами в Immich',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Примеры:
  # Объединить все альбомы с именем "Отпуск" в один
  python immich_migrate_albums.py --target "Отпуск"
  
  # Перенести файлы из альбомов "Поездка" и "Лето" в альбом "Архив"
  python immich_migrate_albums.py --target "Архив" --sources "Поездка" "Лето"
        """
    )
    
    parser.add_argument(
        '--url',
        default=os.environ.get('IMMICH_URL', 'http://localhost:2283'),
        help='URL сервера Immich (по умолчанию: http://localhost:2283)'
    )
    
    parser.add_argument(
        '--api-key',
        default=os.environ.get('IMMICH_API_KEY'),
        help='API ключ Immich (или переменная IMMICH_API_KEY)'
    )
    
    parser.add_argument(
        '--target',
        required=True,
        help='Имя целевого альбома'
    )
    
    parser.add_argument(
        '--sources',
        nargs='+',
        help='Список имен исходных альбомов (если не указан, выполняется объединение дубликатов)'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Режим проверки (показывает что будет сделано, но не выполняет действия)'
    )
    
    args = parser.parse_args()
    
    if not args.api_key:
        print("Ошибка: Не указан API ключ. Используйте --api-key или переменную IMMICH_API_KEY")
        sys.exit(1)
    
    if args.dry_run:
        print("РЕЖИМ DRY RUN - изменения не будут применены")
        print(f"URL: {args.url}")
        print(f"Целевой альбом: {args.target}")
        if args.sources:
            print(f"Исходные альбомы: {', '.join(args.sources)}")
            print("\nБудут выполнены следующие действия:")
            print(f"1. Проверка/создание целевого альбома '{args.target}'")
            print(f"2. Для каждого альбома из списка:")
            print("   - Копирование всех файлов в целевой альбом")
            print("   - Удаление исходного альбома")
        else:
            print("\nБудут выполнены следующие действия:")
            print(f"1. Поиск всех альбомов с именем '{args.target}'")
            print(f"2. Объединение их в первый альбом")
            print(f"3. Удаление альбомов-дубликатов")
        print("\nДля выполнения операции уберите флаг --dry-run")
        sys.exit(0)
    
    try:
        migrator = ImmichAlbumMigrator(args.url, args.api_key)
        migrator.run_migration(args.target, args.sources)
    except Exception as e:
        print(f"\nОшибка: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()