package ssu.groupstudy.domain.round.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.api.round.vo.RoundDtoVo;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.UnauthorizedDeletionException;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.domain.common.enums.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RoundService {
    private final StudyEntityRepository studyEntityRepository;
    private final RoundEntityRepository roundEntityRepository;
    private final int ROUND_LIMIT = 60;

    @Transactional
    public long createRound(long studyId, AppointmentReqVo dto) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        checkRoundMoreThanLimit(study);
        return roundEntityRepository.save(dto.toEntity(study)).getRoundId();
    }

    private void checkRoundMoreThanLimit(StudyEntity study) {
        if (roundEntityRepository.countRoundsByStudy(study) >= ROUND_LIMIT) {
            throw new IllegalStateException(USER_CAN_NOT_CREATE_ROUND.getMessage());
        }
    }

    @Transactional
    public void updateAppointment(long roundId, AppointmentReqVo dto) {
        RoundEntity round = roundEntityRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        round.updateAppointment(dto.toAppointment());
    }

    public RoundDtoVo.RoundDetailResVo getDetail(long roundId) {
        RoundEntity round = roundEntityRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        return RoundDtoVo.createRoundDetail(round);
    }

    @Transactional
    public void updateDetail(long roundId, String detail) {
        RoundEntity round = roundEntityRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        round.updateDetail(detail);
    }

    public List<RoundDtoVo.RoundInfoResVo> getRoundInfoResponses(long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return roundEntityRepository.findRoundsByStudyOrderByStudyTime(study).stream()
                .map(RoundDtoVo::createRoundInfo)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteRound(long roundId, UserEntity user) {
        RoundEntity round = roundEntityRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));

        validateDeleteRound(user, round);
        round.delete();
    }

    private void validateDeleteRound(UserEntity user, RoundEntity round) {
        if (!round.getStudy().isHostUser(user)) {
            throw new UnauthorizedDeletionException(ResultCode.HOST_USER_ONLY_CAN_DELETE_ROUND);
        }
    }
}
