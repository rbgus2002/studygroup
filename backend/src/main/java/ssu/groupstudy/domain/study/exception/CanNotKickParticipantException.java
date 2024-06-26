package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class CanNotKickParticipantException extends BusinessException {
    public CanNotKickParticipantException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public CanNotKickParticipantException(ResultCode resultCode) {
        super(resultCode);
    }
}
