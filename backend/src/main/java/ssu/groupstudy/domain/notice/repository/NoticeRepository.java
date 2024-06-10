package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.entity.StudyEntity;

import java.util.List;
import java.util.Optional;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    @Query("SELECT n FROM Notice n WHERE n.noticeId = :noticeId AND n.deleteYn = 'N'")
    Optional<Notice> findById(Long noticeId);

    Page<Notice> findNoticesByStudyOrderByPinYnDescCreateDateDesc(StudyEntity study, Pageable pageable);

    List<Notice> findTop3ByStudyOrderByPinYnDescCreateDateDesc(StudyEntity study);

    @Query("SELECT n FROM Notice n WHERE n.study = :study AND n.deleteYn = 'N'")
    List<Notice> findNoticesByStudy(StudyEntity study);
}
