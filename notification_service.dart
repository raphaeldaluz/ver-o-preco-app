import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'database_service.dart';
import 'auth_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;

  // Inicializar serviço de notificações
  static Future<void> initialize() async {
    if (_initialized) return;

    // Inicializar timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  // Callback quando notificação é tocada
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notificação tocada: ${response.payload}');
    // TODO: Implementar navegação baseada no payload
  }

  // Solicitar permissões
  static Future<bool> requestPermissions() async {
    // Solicitar permissão do sistema
    final status = await Permission.notification.request();
    
    if (status != PermissionStatus.granted) {
      return false;
    }

    // Solicitar permissões específicas do iOS
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? true;
  }

  // Verificar se notificações estão habilitadas
  static Future<bool> areNotificationsEnabled() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  // Mostrar notificação simples
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!await areNotificationsEnabled()) return;

    const androidDetails = AndroidNotificationDetails(
      'ver_o_preco_channel',
      'Ver-o-Preço',
      channelDescription: 'Notificações do aplicativo Ver-o-Preço',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Notificação de desconto
  static Future<void> notifyPriceDropped({
    required String produtoNome,
    required String supermercadoNome,
    required double precoAntigo,
    required double precoNovo,
    required String produtoCodigo,
  }) async {
    final economia = precoAntigo - precoNovo;
    final percentual = (economia / precoAntigo * 100);

    await showNotification(
      id: produtoCodigo.hashCode,
      title: '💰 Preço baixou!',
      body: '$produtoNome no $supermercadoNome: R\$ ${precoNovo.toStringAsFixed(2)} (${percentual.toStringAsFixed(1)}% off)',
      payload: 'price_drop:$produtoCodigo',
    );
  }

  // Notificação de promoção
  static Future<void> notifyPromotion({
    required String produtoNome,
    required String supermercadoNome,
    required double precoOriginal,
    required double precoPromocional,
    required String produtoCodigo,
  }) async {
    final economia = precoOriginal - precoPromocional;
    final percentual = (economia / precoOriginal * 100);

    await showNotification(
      id: produtoCodigo.hashCode + 1000,
      title: '🔥 Promoção imperdível!',
      body: '$produtoNome em promoção no $supermercadoNome: R\$ ${precoPromocional.toStringAsFixed(2)} (${percentual.toStringAsFixed(1)}% off)',
      payload: 'promotion:$produtoCodigo',
    );
  }

  // Notificação de produto favoritado
  static Future<void> notifyFavoriteProductUpdate({
    required String produtoNome,
    required String supermercadoNome,
    required double precoNovo,
    required String produtoCodigo,
  }) async {
    await showNotification(
      id: produtoCodigo.hashCode + 2000,
      title: '⭐ Produto favorito atualizado',
      body: '$produtoNome no $supermercadoNome: R\$ ${precoNovo.toStringAsFixed(2)}',
      payload: 'favorite_update:$produtoCodigo',
    );
  }

  // Notificação de pontos ganhos
  static Future<void> notifyPointsEarned({
    required int pontos,
    required String motivo,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '🌟 Pontos ganhos!',
      body: 'Você ganhou $pontos pontos: $motivo',
      payload: 'points_earned:$pontos',
    );
  }

  // Agendar notificação
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!await areNotificationsEnabled()) return;

    const androidDetails = AndroidNotificationDetails(
      'ver_o_preco_scheduled',
      'Ver-o-Preço Agendadas',
      channelDescription: 'Notificações agendadas do Ver-o-Preço',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Converter DateTime para TZDateTime
    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancelar notificação
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todas as notificações
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Verificar mudanças de preços para produtos favoritos
  static Future<void> checkFavoriteProductPrices() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      // Buscar produtos favoritos do usuário
      final favoriteProducts = await DatabaseService.getUserFavorites(user.id!);
      
      for (final produtoCodigo in favoriteProducts) {
        // Buscar preços atuais do produto
        final precos = await DatabaseService.getProductPrices(produtoCodigo);
        
        if (precos.isNotEmpty) {
          // Verificar se houve mudança significativa de preço
          final menorPreco = precos.reduce((a, b) {
            final precoA = (a['preco_promocional'] ?? a['preco']) as double;
            final precoB = (b['preco_promocional'] ?? b['preco']) as double;
            return precoA < precoB ? a : b;
          });
          
          // Verificar se é uma mudança recente (últimas 24h)
          final agora = DateTime.now();
          final dataAtualizacao = DateTime.fromMillisecondsSinceEpoch(menorPreco['data_atualizacao']);
          final diferenca = agora.difference(dataAtualizacao);
          
          if (diferenca.inHours <= 24) {
            final precoFinal = (menorPreco['preco_promocional'] ?? menorPreco['preco']) as double;
            
            await notifyFavoriteProductUpdate(
              produtoNome: menorPreco['produto_nome'] ?? 'Produto',
              supermercadoNome: menorPreco['supermercado_nome'] ?? 'Supermercado',
              precoNovo: precoFinal,
              produtoCodigo: produtoCodigo,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar preços de favoritos: $e');
    }
  }

  // Configurar notificações periódicas
  static Future<void> setupPeriodicChecks() async {
    // Agendar verificação diária de preços (meio-dia)
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final scheduledDate = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      12, // meio-dia
      0,
    );

    await scheduleNotification(
      id: 999999,
      title: 'Ver-o-Preço',
      body: 'Verificando novos preços para você...',
      scheduledDate: scheduledDate,
      payload: 'daily_check',
    );
  }

  // Notificação de boas-vindas
  static Future<void> showWelcomeNotification() async {
    await Future.delayed(const Duration(seconds: 5));
    
    await showNotification(
      id: 1,
      title: 'Bem-vindo ao Ver-o-Preço! 🎉',
      body: 'Comece escaneando produtos para comparar preços e economizar!',
      payload: 'welcome',
    );
  }

  // Notificação de lembrete para escanear
  static Future<void> scheduleScanReminder() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    
    await scheduleNotification(
      id: 2,
      title: 'Que tal escanear alguns produtos? 📱',
      body: 'Descubra onde estão os melhores preços da sua região!',
      scheduledDate: tomorrow,
      payload: 'scan_reminder',
    );
  }

  // Obter estatísticas de notificações
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

