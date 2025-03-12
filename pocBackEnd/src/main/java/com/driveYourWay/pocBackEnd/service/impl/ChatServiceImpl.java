package com.driveYourWay.pocBackEnd.service.impl;

import com.driveYourWay.pocBackEnd.dto.ChatMessageDTO;
import com.driveYourWay.pocBackEnd.model.ChatMessage;
import com.driveYourWay.pocBackEnd.repository.ChatRepository;
import com.driveYourWay.pocBackEnd.service.ChatService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChatServiceImpl implements ChatService {

    private final ChatRepository chatRepository;
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public ChatServiceImpl(ChatRepository chatRepository) {
        this.chatRepository = chatRepository;
    }

    @Override
    public ChatMessageDTO saveMessage(ChatMessageDTO messageDTO) {
        System.out.println("📩 Message reçu : " + messageDTO);
        if (messageDTO.getContent() == null || messageDTO.getContent().trim().isEmpty()) {
            System.out.println("🚨 Erreur : Le message est vide !");
            throw new IllegalArgumentException("Le message ne peut pas être vide");
        }

        ChatMessage message = ChatMessage.builder()
                .sender(messageDTO.getSender())
                .content(messageDTO.getContent())
                .timestamp(LocalDateTime.now())
                .build();

        ChatMessage savedMessage = chatRepository.save(message);

        return new ChatMessageDTO(
                savedMessage.getSender(),
                savedMessage.getContent(),
                savedMessage.getTimestamp().format(formatter)
        );
    }

    @Override
    public List<ChatMessageDTO> getAllMessages() {
        return chatRepository.findAllByOrderByTimestampDesc().stream()
                .map(msg -> new ChatMessageDTO(
                        msg.getSender(),
                        msg.getContent(),
                        msg.getTimestamp().format(formatter)  // Conversion en String pour JSON
                ))
                .collect(Collectors.toList());
    }
}
