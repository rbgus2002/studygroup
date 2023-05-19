package ssu.groupstudy.domain.notice.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class NoticeNotFoundException extends BusinessException {
    public NoticeNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
