package ssu.groupstudy.domain.user.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class UserNotFoundException extends BusinessException {
    public UserNotFoundException(ResultCode resultCode){
        super(resultCode);
    }
}
