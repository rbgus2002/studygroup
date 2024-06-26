package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.param.ParticipantInfo;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CustomRepositoryTest
class ParticipantEntityRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserEntityRepository userEntityRepository;
    @Autowired
    private StudyEntityRepository studyEntityRepository;
    @Autowired
    private ParticipantEntityRepository participantEntityRepository;

    @DisplayName("스터디에 소속되어있는 사용자인지 확인한다")
    @Test
    void isParticipated() {
        // given
        UserEntity 최규현 = userEntityRepository.findById(1L).get();
        StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
        스터디.invite(최규현);

        // when
        boolean isParticipated = 스터디.isParticipated(최규현);

        // then
        softly.assertThat(isParticipated).isTrue();
    }

    @Nested
    class invite {
        @DisplayName("이미 참여중인 사용자를 스터디에 초대하면 예외를 던진다")
        @Test
        void userAlreadyExist() {
            // given
            UserEntity 최규현 = userEntityRepository.findById(1L).get();
            StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
            스터디.invite(최규현);

            // when, then
            softly.assertThatThrownBy(() -> 스터디.invite(최규현))
                    .isInstanceOf(InviteAlreadyExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_INVITE_USER.getMessage());
        }

        @DisplayName("새로운 사용자를 스터디에 초대한다")
        @Test
        void success() {
            // given
            UserEntity 최규현 = userEntityRepository.findById(1L).get();
            StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
            스터디.invite(최규현);

            // when
            Optional<ParticipantEntity> 최규현_스터디 = participantEntityRepository.findByUserAndStudy(최규현, 스터디);

            // then
            softly.assertThat(최규현_스터디).isNotEmpty();
        }
    }

    @Nested
    class leave {
        @DisplayName("참여중이지 않은 사용자가 스터디 탈퇴를 시도하면 예외를 던진다")
        @Test
        void fail_userNotFound() {
            // given
            UserEntity 장재우 = userEntityRepository.findById(2L).get();
            StudyEntity 스터디 = studyEntityRepository.findById(1L).get();


            // when, then
            softly.assertThatThrownBy(() -> 스터디.leave(장재우))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(ResultCode.USER_NOT_PARTICIPATED.getMessage());
        }

        @DisplayName("방장은 스터디에 탈퇴할 수 없다")
        @Test
        void fail_hostUserInvalid() {
            // given, then
            UserEntity 최규현 = userEntityRepository.findById(1L).get();
            UserEntity 장재우 = userEntityRepository.findById(2L).get();
            StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
            스터디.invite(최규현);
            스터디.invite(장재우);

            // when
            softly.assertThatThrownBy(() -> 스터디.leave(최규현))
                    .isInstanceOf(CanNotLeaveStudyException.class)
                    .hasMessage(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY.getMessage());
        }

        @DisplayName("사용자가 스터디에서 탈퇴한다")
        @Test
        void success() {
            // given
            UserEntity 장재우 = userEntityRepository.findById(2L).get();
            StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
            스터디.invite(장재우);

            // when
            스터디.leave(장재우);
            boolean isParticipated = 스터디.isParticipated(장재우);

            // then
            softly.assertThat(isParticipated).isFalse();
        }
    }

    @Test
    @DisplayName("스터디에 소속된 사용자를 초대순서로 정렬해서 모두 불러온다")
    void getParticipantsOrderByCreateDateAsc() {
        // given
        UserEntity 최규현 = userEntityRepository.findById(1L).get();
        UserEntity 장재우 = userEntityRepository.findById(2L).get();
        StudyEntity 스터디 = studyEntityRepository.findById(1L).get();
        participantEntityRepository.save(new ParticipantEntity(최규현, 스터디));
        participantEntityRepository.save(new ParticipantEntity(장재우, 스터디));

        // when
        List<ParticipantEntity> participants = 스터디.getParticipantList().stream()
                .sorted(Comparator.comparing(ParticipantEntity::getCreateDate))
                .collect(Collectors.toList());

        // then
        softly.assertThat(participants.size()).isEqualTo(2);
        softly.assertThat(participants.get(0).getCreateDate()).isBefore(participants.get(1).getCreateDate());
    }

    @Test
    @DisplayName("사용자가 참여중인 스터디의 이름들을 가져온다")
    void findStudyNamesByUser(){
        // given
        UserEntity 최규현 = userEntityRepository.findById(1L).get();
        StudyEntity 알고스터디 = studyEntityRepository.findById(1L).get();
        StudyEntity 영어스터디 = studyEntityRepository.findById(2L).get();
        participantEntityRepository.save(new ParticipantEntity(최규현, 알고스터디));
        participantEntityRepository.save(new ParticipantEntity(최규현, 영어스터디));

        // when
        List<ParticipantInfo> participantInfoList = participantEntityRepository.findParticipantInfoByUser(최규현);

        // then
        softly.assertThat(participantInfoList.size()).isEqualTo(2);
    }

    @Test
    @DisplayName("사용자가 참여중인 스터디의 개수를 가져온다")
    void countParticipationStudy(){
        // given
        UserEntity 최규현 = userEntityRepository.findById(1L).get();
        StudyEntity 알고스터디 = studyEntityRepository.findById(1L).get();
        StudyEntity 영어스터디 = studyEntityRepository.findById(2L).get();

        // when
        알고스터디.invite(최규현);
        영어스터디.invite(최규현);
        final int participationStudyBeforeDelete = participantEntityRepository.countParticipationStudy(최규현);

        영어스터디.delete();
        final int participationStudyAfterDelete = participantEntityRepository.countParticipationStudy(최규현);

        // then
        softly.assertThat(participationStudyBeforeDelete).isEqualTo(2);
        softly.assertThat(participationStudyAfterDelete).isEqualTo(participationStudyBeforeDelete - 1);
    }
}