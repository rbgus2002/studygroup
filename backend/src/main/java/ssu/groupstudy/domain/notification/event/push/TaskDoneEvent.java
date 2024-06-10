package ssu.groupstudy.domain.notification.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class TaskDoneEvent{
    private final UserEntity user;
    private final TaskEntity task;

    public Long getStudyId(){
        return task.getStudy().getStudyId();
    }

    public Long getRoundId(){
        return task.getRoundParticipant().getRound().getRoundId();
    }

    public String getStudyName(){
        return task.getStudy().getStudyName();
    }

    public String getNickname(){
        return user.getNickname();
    }

    public String getTaskDetail(){
        return task.getDetail();
    }
}