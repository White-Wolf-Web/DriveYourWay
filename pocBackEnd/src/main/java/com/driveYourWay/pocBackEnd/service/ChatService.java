package com.driveYourWay.pocBackEnd.service;

import com.driveYourWay.pocBackEnd.dto.ChatMessageDTO;
import java.util.List;

public interface ChatService {
    ChatMessageDTO saveMessage(ChatMessageDTO message);
    List<ChatMessageDTO> getAllMessages();
}
