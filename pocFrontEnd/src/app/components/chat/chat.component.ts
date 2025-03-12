import { Component } from '@angular/core';
import { ChatService } from '../../services/chat.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-chat',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './chat.component.html',
  styleUrl: './chat.component.css'
})
export class ChatComponent {
  messages: { sender: string; content: string }[] = [];
  messageInput: string = '';
  username: string = '';
  isUsernameSet: boolean = false;

  constructor(private chatService: ChatService) {
    this.chatService.messages$.subscribe((msgs) => {
      console.log("📥 Messages reçus :", msgs); // 🔍 Vérifie les messages dans la console
  
      // ✅ Correction : conversion des noms de propriétés
      this.messages = msgs.map(msg => ({
        sender: msg.sender,   // ✅ Assure-toi que c'est bien 'sender'
        content: msg.content  // ✅ Assure-toi que c'est bien 'content'
      }));
    });
  }
  
  
  

  setUsername() {
    if (this.username.trim()) {
      this.isUsernameSet = true;
    }
  }

  sendMessage() {
    if (this.messageInput.trim()) {
      this.chatService.sendMessage(this.username, this.messageInput);
      this.messageInput = '';
    }
  }
}