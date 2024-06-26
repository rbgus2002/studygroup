package ssu.groupstudy.api.study.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class StudySummaryResVo {
    private Long studyId;
    private String studyName;
    private String detail;
    private String picture;
    private String color;
    private Long hostUserId;

    private StudySummaryResVo(StudyEntity study, ParticipantEntity participant){
        this.studyId = study.getStudyId();
        this.studyName = study.getStudyName();
        this.detail = study.getDetail();
        this.picture = study.getPicture();
        this.color = participant.getColor();
        this.hostUserId = study.getHostUser().getUserId();
    }

    public static StudySummaryResVo from(StudyEntity study, ParticipantEntity participant){
        return new StudySummaryResVo(study, participant);
    }
}
