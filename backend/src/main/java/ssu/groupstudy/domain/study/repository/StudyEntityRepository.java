package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.param.DoneCount;
import ssu.groupstudy.domain.study.param.StatusTagInfo;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.Optional;

public interface StudyEntityRepository extends JpaRepository<StudyEntity, Long> {
    @Query("SELECT s FROM StudyEntity s WHERE s.studyId = :studyId AND s.deleteYn = false")
    Optional<StudyEntity> findById(Long studyId);

    @Query("SELECT s FROM StudyEntity s WHERE s.inviteCode = :inviteCode AND s.deleteYn = false")
    Optional<StudyEntity> findByInviteCode(String inviteCode);

    @Query("SELECT new ssu.groupstudy.domain.study.param.StatusTagInfo(rp.statusTag, COUNT(r.roundId)) " +
            "FROM StudyEntity s " +
            "JOIN RoundEntity r ON s.studyId = r.study.studyId " +
            "JOIN RoundParticipantEntity rp ON r.roundId = rp.round.roundId " +
            "WHERE s = :study " +
            "AND rp.user = :user " +
            "AND s.deleteYn = false " +
            "AND r.deleteYn = false " +
            "GROUP BY rp.statusTag")
    List<StatusTagInfo> calculateStatusTag(UserEntity user, StudyEntity study);

    @Query("SELECT new ssu.groupstudy.domain.study.param.DoneCount(SUM(CASE WHEN t.doneYn = 'Y' THEN 1 ELSE 0 END), " +
            "SUM(CASE WHEN t.doneYn = 'N' THEN 1 ELSE 0 END), " +
            "COUNT(t.doneYn))" +
            "FROM StudyEntity s " +
            "JOIN RoundEntity r ON s.studyId = r.study.studyId " +
            "JOIN RoundParticipantEntity rp ON r.roundId = rp.round.roundId " +
            "JOIN TaskEntity t ON rp.id = t.roundParticipant.id " +
            "WHERE s = :study " +
            "AND rp.user = :user " +
            "AND s.deleteYn = false " +
            "AND r.deleteYn = false "
    )
    DoneCount calculateDoneCount(UserEntity user, StudyEntity study);
}
