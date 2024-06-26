package ssu.groupstudy.domain.rule.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.rule.entity.RuleEntity;
import ssu.groupstudy.api.rule.vo.CreateRuleReqVo;
import ssu.groupstudy.api.rule.vo.UpdateRuleReqVo;
import ssu.groupstudy.api.rule.vo.RuleResVo;
import ssu.groupstudy.domain.rule.exception.RuleNotFoundException;
import ssu.groupstudy.domain.rule.repository.RuleEntityRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RuleService {
    private final StudyEntityRepository studyEntityRepository;
    private final RuleEntityRepository ruleEntityRepository;

    @Transactional
    public Long createRule(CreateRuleReqVo dto) {
        StudyEntity study = studyEntityRepository.findById(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        RuleEntity rule = dto.toEntity(study);
        return ruleEntityRepository.save(rule).getId();
    }

    @Transactional
    public void deleteRule(Long ruleId) {
        RuleEntity rule = ruleEntityRepository.findById(ruleId)
                .orElseThrow(() -> new RuleNotFoundException(ResultCode.RULE_NOT_FOUND));
        rule.delete();
    }

    @Transactional
    public void updateRule(Long ruleId, UpdateRuleReqVo request) {
        RuleEntity rule = ruleEntityRepository.findById(ruleId)
                .orElseThrow(() -> new RuleNotFoundException(ResultCode.RULE_NOT_FOUND));
        rule.updateDetail(request.getDetail());
    }

    public List<RuleResVo> getRules(Long studyId) {
        List<RuleEntity> rules = ruleEntityRepository.findRulesByStudyIdOrderByCreateDate(studyId);
        return rules.stream()
                .map(RuleResVo::of)
                .collect(Collectors.toList());
    }
}
