package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InvalidRoundParticipantException extends BusinessException {
    public InvalidRoundParticipantException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public InvalidRoundParticipantException(ResultCode resultCode) {
        super(resultCode);
    }
}
