package ssu.groupstudy.domain.notification.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ChannelCode {
    NOTICE("공지사항"),
    POKE("콕찌르기"),
    ROUND("회차"),
    TASK("과제"),
    ;

    private final String name;
}