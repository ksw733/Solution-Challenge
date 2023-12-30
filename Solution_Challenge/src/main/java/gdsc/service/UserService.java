package gdsc.service;

import gdsc.domain.User;
import gdsc.dto.Token;
import gdsc.dto.UserRequestDto;
import gdsc.dto.UserResponseDto;
import gdsc.jwt.TokenProvider;
import gdsc.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;

    @Transactional
    public UserResponseDto signup(UserRequestDto userRequestDto){
        if(userRepository.existsByEmail(userRequestDto.getEmail())){
            throw new RuntimeException("이미 가입되어 있는 사용자입니다.");
        }
        User user = userRequestDto.toUser(passwordEncoder);
        return UserResponseDto.of(userRepository.save(user));
    }

    @Transactional
    public Token login(UserRequestDto userRequestDto){
        // 사용자 인증을 위한 토큰 생성
        UsernamePasswordAuthenticationToken authenticationToken = userRequestDto.toAuthentication();
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        // 토큰 생성
        Token token = tokenProvider.generateTokenDto(authentication);

        return token;
    }

    @Transactional
    public Optional<User> getUserById(long id) {
        return userRepository.findUserById(id);
    }

}