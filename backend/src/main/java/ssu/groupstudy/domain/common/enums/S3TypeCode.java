package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum S3TypeCode {
    USER_IMAGE("profile/user/%d/%s", "[사용자 프로필 이미지] userId, UUID"),
    STUDY_IMAGE("profile/study/%d/%s", "[스터디 프로필 이미지] userId, UUID"),
    ;

    private final String format;
    private final String description;
}
