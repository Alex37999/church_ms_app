#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  // Simple dove/leaf icon in base64 (a 64x64 PNG with a religious symbol)
  const String base64Icon = 
    'iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAA0UlEQVR4nO3ZsQkCURRA0ZuIiZjZhZmNqZhYmImJhYWZmImJmJmFiZmImYmJhZmJiZgIFiKKoKAgIsj7YBQhJtz7ztx74XlfVVVVVVVVVf2fxHE8juNoPp/PGY/Ho/P5nDAMRZZlRZ7nRZfLRXieJ7vdTnmuK9vtVh6PB+VyWXmeJ+PxWA6HA5VKRb7fb3meJ4qi6Hw+y+FwkNPpJNvtVjabDR0Oh2I+nxO/309cLhcql6uSyWRULBZluVzKZrOhv78/Go1Gut1u0ul0qFqt0ng8Lo/HQ7rdLg2HQ9psNqTTKWU+n0sgECAul4tGoxHZ7XZSqVQkCILf9W1V/TtyHEfGYrF/7tdVVVVV/RN+AVW7zH9lVZoqAAAAAElFTkSuQmCC';

  final bytes = base64Decode(base64Icon);
  final file = File('assets/icon/app_icon.png');
  await file.create(recursive: true);
  await file.writeAsBytes(bytes);
  print('Created: assets/icon/app_icon.png');
}
