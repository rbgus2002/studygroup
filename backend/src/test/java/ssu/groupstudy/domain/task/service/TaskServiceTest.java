package ssu.groupstudy.domain.task.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static ssu.groupstudy.global.ResultCode.*;

class TaskServiceTest extends ServiceTest {
    @InjectMocks
    private TaskService taskService;
    @Mock
    private RoundRepository roundRepository;
    @Mock
    private TaskRepository taskRepository;

    @Nested
    class DeleteTask{
        @Test
        @DisplayName("태스크가 존재하지 않는 경우 예외를 던진다.")
        void TaskNotFound(){
            // given, when
            doReturn(Optional.empty()).when(taskRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.deleteTask(-1L))
                    .isInstanceOf(TaskNotFoundException.class)
                    .hasMessage(TASK_NOT_FOUND.getMessage());
        }
    }

    @Nested
    class GetTasks{
        @Test
        @DisplayName("회차가 존재하지 않는 경우 예외를 던진다")
        void roundNotFound(){
            // given, when
            doReturn(Optional.empty()).when(roundRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> taskService.getTasks(-1L))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }
    }
}