package com.meomureum.springboot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.meomureum.springboot.dao.IMemberDAO;
import com.meomureum.springboot.dto.MemberDTO;

@Service
public class MemberUserDetailsService implements UserDetailsService{
	
	@Autowired
	IMemberDAO dao;
		
	@Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberDTO dto = dao.selectDAOById(username);
        if (dto == null) {
            throw new UsernameNotFoundException("사용자 없음");
        }

        return User.builder()
                .username(dto.getM_id())
                .password(dto.getM_passwd())
                .roles(dto.getM_auth())
                .build();
    }
	
}
