import { Injectable } from '@angular/core';
import { Client } from '@stomp/stompjs';
import SockJS from 'sockjs-client';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ChatService {
  private stompClient!: Client;

  // ✅ Correction : maintenant on utilise { sender, content } pour correspondre au backend
  private messagesSubject = new BehaviorSubject<{ sender: string; content: string }[]>([]);
  messages$: Observable<{ sender: string; content: string }[]> = this.messagesSubject.asObservable();

  constructor() {
    this.connect();
  }

  private connect() {
    const socket = new SockJS('http://localhost:8080/ws');
    this.stompClient = new Client({
      webSocketFactory: () => socket,
      debug: (str) => console.log(str),
      reconnectDelay: 5000,
    });

    this.stompClient.onConnect = () => {
      console.log('✅ WebSocket connecté');

      // ✅ Correction : Ajout d'un console.log pour voir ce qui est reçu
      this.stompClient.subscribe('/topic/messages', (message) => {
        const receivedMsg = JSON.parse(message.body);
        console.log("📩 Message WebSocket reçu :", receivedMsg);

        // ✅ Ajout du message en conservant la liste existante
        this.messagesSubject.next([...this.messagesSubject.value, receivedMsg]);
      });
    };

    this.stompClient.activate();
  }

  sendMessage(sender: string, content: string) {
    if (!this.stompClient || !this.stompClient.connected) {
      console.error('🚨 STOMP non connecté !');
      return;
    }

    if (!content.trim()) {
      console.warn("🚨 Tentative d'envoi d'un message vide !");
      return;
    }

    const chatMessage = {
      sender: sender,
      content: content,
      timestamp: new Date().toISOString(),
    };

    console.log('📤 Envoi du message JSON.stringify :', JSON.stringify(chatMessage));

    this.stompClient.publish({
      destination: '/app/sendMessage',
      body: JSON.stringify(chatMessage),
    });
  }
}
