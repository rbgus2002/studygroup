package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class TaskGroups {
    private TaskType taskType;
    private List<TaskInfo> tasks;

    private TaskGroups(TaskType taskType, RoundParticipant roundParticipant) {
        this.taskType = taskType;
        this.tasks = roundParticipant.getTasks().stream()
                .filter(task -> task.isSameTypeOf(taskType))
                .sorted(Comparator.comparing(Task::getDoneYn)
                        .thenComparing(Task::getId))
                .map(TaskInfo::from)
                .collect(Collectors.toList());
    }

    public static TaskGroups of(TaskType type, RoundParticipant roundParticipant){
        return new TaskGroups(type, roundParticipant);
    }
}