package com.driveYourWay.pocBackEnd.controller;

import com.driveYourWay.pocBackEnd.dto.ChatMessageDTO;
import com.driveYourWay.pocBackEnd.service.ChatService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    // ✅ API REST pour envoyer un message
    @PostMapping("/messages")
    public ChatMessageDTO sendMessage(@RequestBody ChatMessageDTO messageDTO) {
        return chatService.saveMessage(messageDTO);
    }

    // ✅ API REST pour récupérer les messages
    @GetMapping("/messages")
    public List<ChatMessageDTO> getMessages() {
        return chatService.getAllMessages();
    }

    // ✅ WebSocket : Recevoir et diffuser un message
    @MessageMapping("/sendMessage")
    @SendTo("/topic/messages")
    public ChatMessageDTO broadcastMessage(@Payload ChatMessageDTO chatMessageDTO) {
        System.out.println("📩 Message reçu du frontend: " + chatMessageDTO);

        if (chatMessageDTO.getContent() == null || chatMessageDTO.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Le message ne peut pas être vide");
        }

        return chatService.saveMessage(chatMessageDTO);
    }
}
