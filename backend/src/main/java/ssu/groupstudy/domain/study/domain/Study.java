package ssu.groupstudy.domain.study.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.global.constant.Color;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.util.List;
import java.util.Optional;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "study")
public class Study extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long studyId;

    @Column(nullable = false, length = 14)
    private String studyName;

    @Column(length = 20)
    private String detail;

    @Column(nullable = false)
    private String picture;

    @Column(nullable = false, unique = true, length = 6)
    private String inviteCode;

    @Embedded
    private Participants participants;

    @Column(nullable = false)
    private char deleteYn;

    private Study(String studyName, String detail, String color, User hostUser, String inviteCode) {
        this.studyName = studyName;
        this.detail = detail;
        this.participants = Participants.empty(new Participant(hostUser, this), color);
        this.inviteCode = inviteCode;
        this.deleteYn = 'N';
    }

    private Study(String studyName, String detail) {
        this.studyName = studyName;
        this.detail = detail;
    }

    public static Study init(String studyName, String detail, String color, User hostUser, String inviteCode) {
        return new Study(studyName, detail, color, hostUser, inviteCode);
    }

    public static Study create(String studyName, String detail) {
        return new Study(studyName, detail);
    }

    public boolean isParticipated(User user) {
        return participants.existParticipant(new Participant(user, this));
    }

    public void invite(User user) {
        if (isParticipated(user)) {
            throw new InviteAlreadyExistsException(ResultCode.DUPLICATE_INVITE_USER);
        }
        Optional<Participant> hostParticipant = this.participants.getHostParticipant();
        String color = Color.DEFAULT.getHex();
        if(hostParticipant.isPresent()){
            color = hostParticipant.get().getColor();
        }
        Participant participant = Participant.createWithColor(user, this, color);
        participants.addParticipant(participant);
    }

    public void leave(User user) {
        if (!isParticipated(user)) {
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
        if (isHostUser(user) && participants.isGreaterThanOne()) {
            throw new CanNotLeaveStudyException(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY);
        }
        participants.removeParticipant(new Participant(user, this));
        if (participants.isNoOne()) {
            delete();
        }
    }

    public boolean isHostUser(User user) {
        return participants.isHostUser(user);
    }

    public List<Participant> getParticipantList() {
        return this.participants.getParticipants();
    }

    public void delete() {
        this.deleteYn = 'Y';
    }

    public void updatePicture(String picture) {
        this.picture = picture;
    }

    public User getHostUser() {
        return this.participants.getHostUser();
    }

    public void edit(String studyName, String detail, User hostUser) {
        this.studyName = studyName;
        this.detail = detail;
        this.participants.changeHostUser(hostUser);
    }

    public void kickParticipant(User user) {
        if (!isParticipated(user)) {
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
        participants.removeParticipant(new Participant(user, this));
    }
}
