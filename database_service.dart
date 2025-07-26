    for (int i = 0; i <= now.difference(dataCadastro).inDays; i++) {
      final loginDate = dataCadastro.add(Duration(days: i));
      if (loginDate.isBefore(now) || loginDate.isAtSameMomentAs(now)) {
        history.add({
          'user_id': userId,
          'data_ultimo_login': loginDate.millisecondsSinceEpoch,
        });
      }
    }
    
    return history;
  }

  static Future<int> insertPointsHistory(Map<String, dynamic> pointsHistory) async {
    final db = await database;
    return await db.insert(_tablePointsHistory, pointsHistory);
  }

  static Future<List<Map<String, dynamic>>> getUserPointsHistory(int userId) async {
    final db = await database;
    return await db.query(
      _tablePointsHistory,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'data_criacao DESC',
    );
  }
}

