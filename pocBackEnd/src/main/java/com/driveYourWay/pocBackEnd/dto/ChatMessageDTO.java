package com.driveYourWay.pocBackEnd.dto;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatMessageDTO {
    @NotBlank(message = "Le champ sender ne peut pas être vide")
    private String sender;

    @NotBlank(message = "Le champ content ne peut pas être vide")
    private String content;

    private String timestamp;
}