package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;


@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyCreateService {
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;
    private final ParticipantRepository participantRepository;

    @Transactional
    public Study createStudy(CreateStudyRequest dto) {
        User hostUser = userRepository.findByUserId(dto.getHostUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        // 새로운 스터디 생성
        Study newStudy = dto.toEntity(hostUser);
        newStudy = studyRepository.save(newStudy);

        return newStudy;
    }
}
