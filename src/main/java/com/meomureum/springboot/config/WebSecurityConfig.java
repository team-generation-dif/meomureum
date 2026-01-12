package com.meomureum.springboot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class WebSecurityConfig {
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder(); // 비밀번호 암호화
	}
	
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		http.csrf((csrf) -> csrf.disable()) // csrf 보호 비활성화
			.cors((cors) -> cors.disable()) // cors 비활성화
			.authorizeHttpRequests(request -> request
					.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll() // 내부 포워드 요청
					.requestMatchers("/").permitAll() //루트(/)는 모두 허용
					.requestMatchers("/CSS/**","/JS/**","/imgsrc/**").permitAll() // 정적 리소스 모두 허용
					.requestMatchers("/guest/**").permitAll() // guest 폴더는 모두 허용
					.requestMatchers("/user/**").hasAnyRole("USER","ADMIN") //user 폴더는 USER, ADMIN만 허용
					.requestMatchers("/admin/**").hasAnyRole("ADMIN") // admin 폴더는 ADMIN만 허용
					.anyRequest().authenticated() // 나머지는 모두 인증 필요
			);
		
		// 사용자 정의 로그인창
		http.formLogin((formlogin) -> formlogin
				.loginPage("/guest/loginForm") // 매핑주소
				.loginProcessingUrl("/j_spring_security_check") // 위 폼태그 페이지의 action
				.usernameParameter("j_username")
				.passwordParameter("j_password")
				.defaultSuccessUrl("/loginSuccess", true)
				.failureUrl("/guest/loginForm?error")
				.permitAll()
				);
		
		// 로그아웃
		http.logout((logout) -> logout
				.logoutUrl("/logout") // 매핑주소
				.logoutSuccessUrl("/") // 로그아웃 성공 시 이동 페이지
				.invalidateHttpSession(true)  // 세션 무효화
			    .deleteCookies("JSESSIONID")  // 쿠키 삭제
				.permitAll()
				);
		
		return http.build();
	}
	
}
