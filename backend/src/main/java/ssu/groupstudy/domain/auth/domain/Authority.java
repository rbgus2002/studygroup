package ssu.groupstudy.domain.auth.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.UserEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "authority")
public class Authority {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "authority_id")
    private Long id;

    @Column(name = "role_name", nullable = false)
    private String name;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="user_id", nullable = false)
    @JsonIgnore
    private UserEntity user;

    private Authority(String name, UserEntity user) {
        this.name = name;
        this.user = user;
    }

    public static Authority init(UserEntity user){
        return new Authority("ROLE_USER", user);
    }
}
