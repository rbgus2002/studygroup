package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class CanNotCreateStudyException extends BusinessException {
    public CanNotCreateStudyException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public CanNotCreateStudyException(ResultCode resultCode) {
        super(resultCode);
    }
}
