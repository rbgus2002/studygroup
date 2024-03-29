package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Optional;

public interface RoundParticipantRepository extends JpaRepository<RoundParticipant, Long> {
    Optional<RoundParticipant> findByUserAndRound(User user, Round round);
}
