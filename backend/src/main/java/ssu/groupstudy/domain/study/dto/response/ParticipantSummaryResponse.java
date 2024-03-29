package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantSummaryResponse {
    private Long userId;
    private String picture;
    private String nickname;

    private ParticipantSummaryResponse(Participant participant) {
        User user = participant.getUser();
        this.userId = user.getUserId();
        this.picture = user.getPicture();
        this.nickname = user.getNickname();
    }

    public static ParticipantSummaryResponse from(Participant participant){
        return new ParticipantSummaryResponse(participant);
    }
}
