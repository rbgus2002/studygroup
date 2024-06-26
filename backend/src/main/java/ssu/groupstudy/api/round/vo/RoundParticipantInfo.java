package ssu.groupstudy.api.round.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE) // [2024-06-10:최규현] TODO: inner 변경
public class RoundParticipantInfo {
    private Long roundParticipantId;
    private Long userId;
    private String picture;
    private StatusTag statusTag;
    private double taskProgress;

    private RoundParticipantInfo(RoundParticipantEntity participant) {
        this.roundParticipantId = participant.getId();
        this.userId = participant.getUser().getUserId();
        this.picture = participant.getUser().getPicture();
        this.statusTag = participant.getStatusTag();
        this.taskProgress = participant.calculateTaskProgress();
    }

    public static RoundParticipantInfo from(RoundParticipantEntity participant){
        return new RoundParticipantInfo(participant);
    }
}
