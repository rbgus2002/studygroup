package ssu.groupstudy.domain.study.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.Appointment;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.dto.response.ParticipantProfileResponse;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.task.dto.response.TaskGroup;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Getter
public class StudyInfoResponse {
    private Long studyId;
    private String studyName;
    private String picture;
    private String color;

    private Long roundSeq;
    private Long roundId;
    private String studyPlace;
    private LocalDateTime studyTime;
    private List<ParticipantProfileResponse> profiles;
    private Long roundParticipantId;
    private List<TaskGroup> taskGroups;

    public StudyInfoResponse(Participant participant, Long roundSeq, Round latestRound, RoundParticipant roundParticipant) {
        Study study = participant.getStudy();
        this.studyId = study.getStudyId();
        this.studyName = study.getStudyName();
        this.picture = study.getPicture();
        this.color = participant.getColor();

        this.roundSeq = roundSeq;
        if(latestRound != null){
            this.roundId = latestRound.getRoundId();
            Appointment appointment = latestRound.getAppointment();
            this.studyPlace = appointment.getStudyPlace();
            this.studyTime = appointment.getStudyTime();
            this.profiles = latestRound.getRoundParticipants().stream()
                    .sorted(Comparator.comparing(RoundParticipant::getId))
                    .map(ParticipantProfileResponse::from)
                    .collect(Collectors.toList());
            this.roundParticipantId = roundParticipant.getId();
            this.taskGroups = Stream.of(TaskType.values())
                    .map(taskType -> TaskGroup.of(taskType, roundParticipant))
                    .collect(Collectors.toList());
        }
    }

    public static StudyInfoResponse of(Participant participant, Long roundSeq, Round latestRound, RoundParticipant roundParticipant){
        return new StudyInfoResponse(participant, roundSeq, latestRound, roundParticipant);
    }
}
