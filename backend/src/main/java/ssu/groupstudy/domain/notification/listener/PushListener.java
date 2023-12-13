package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.domain.TopicCode;
import ssu.groupstudy.domain.notification.domain.event.push.TaskDoneEvent;
import ssu.groupstudy.global.util.FcmUtils;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PushListener {
    private final FcmUtils fcmUtils;

//    @EventListener
//    public void handleCommentCreationEvent(CommentCreationEvent event) {
//        StringBuilder body = new StringBuilder();
//        body.append("새로운 댓글이 달렸어요: ").append(event.getCommentContents());
//        fcmUtils.sendNotificationToTopic(event.getStudyName(), body.toString(), TopicCode.NOTICE, event.getNoticeId());
//    }
//
//    @EventListener
//    public void handleNoticeCreationEvent(NoticeCreationEvent event) {
//        StringBuilder body = new StringBuilder();
//        body.append("새로운 공지사항이 작성되었어요: ").append(event.getNoticeTitle());
//        fcmUtils.sendNotificationToTopic(event.getStudyName(), body.toString(), TopicCode.STUDY, event.getStudyId());
//    }

    @EventListener
    public void handleTaskDoneEvent(TaskDoneEvent event) {
        StringBuilder body = new StringBuilder();
        body.append("'").append(event.getNickname()).append("'").append("님이 과제를 완료했어요: ").append(event.getTaskDetail());
        fcmUtils.sendNotificationToTopic(event.getStudyName(), body.toString(), TopicCode.STUDY, event.getStudyId(), "roundId", event.getRoundId().toString());
    }
}
