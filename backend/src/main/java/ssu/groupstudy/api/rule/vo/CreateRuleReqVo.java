package ssu.groupstudy.api.rule.vo;

import lombok.*;
import ssu.groupstudy.domain.rule.entity.RuleEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@Getter
@ToString
public class CreateRuleReqVo {
    @NotNull
    private Long studyId;
    @NotBlank
    private String detail;

    public RuleEntity toEntity(StudyEntity study){
        return RuleEntity.create(this.detail, study);
    }
}
