package ssu.groupstudy.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.user.domain.UserEntity;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, Long> {
    @Query("SELECT u FROM UserEntity u WHERE u.userId = :userId AND u.deleteYn = 'N'")
    Optional<UserEntity> findById(Long userId);

    boolean existsByPhoneNumber(String phoneNumber);

    @Query("SELECT u FROM UserEntity u WHERE u.phoneNumber = :phoneNumber AND u.deleteYn = 'N'")
    Optional<UserEntity> findByPhoneNumber(String phoneNumber);
}
