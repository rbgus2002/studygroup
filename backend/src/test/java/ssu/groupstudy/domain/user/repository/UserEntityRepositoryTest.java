package ssu.groupstudy.domain.user.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Optional;

@CustomRepositoryTest
class UserEntityRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserEntityRepository userEntityRepository;

    @Test
    @DisplayName("휴대폰 번호로 사용자를 조회한다. 삭제된 회원의 경우 조회하지 않는다.")
    void findByPhoneNumber(){
        // given
        // when
        Optional<UserEntity> deletedUser = userEntityRepository.findByPhoneNumber("01000000000");

        // then
        softly.assertThat(deletedUser).isEmpty();
    }
}