package ssu.groupstudy.domain.user.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class UserNotParticipatedException extends BusinessException {
    public UserNotParticipatedException(ResultCode resultCode){
        super(resultCode);
    }
}
