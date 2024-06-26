package ssu.groupstudy.api.round.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.round.service.RoundParticipantService;
import ssu.groupstudy.api.common.vo.ResVo;

@RestController
@RequestMapping("/api/rounds/participants")
@RequiredArgsConstructor
@Tag(name = "RoundEntity ParticipantEntity", description = "회차 참여자 API")
public class RoundParticipantController {
    private final RoundParticipantService roundParticipantService;

    @Operation(summary = "출석 태그 수정", description = "[NONE, ATTENDANCE, ATTENDANCE_EXPECTED, LATE, ABSENT] 중에 하나로 출석 태그를 변경한다")
    @PutMapping("/{roundParticipantId}")
    public ResVo updateStatusTag(@PathVariable Long roundParticipantId, @RequestParam StatusTag statusTag){
        roundParticipantService.updateStatusTag(roundParticipantId, statusTag);
        return ResVo.success();
    }
}
