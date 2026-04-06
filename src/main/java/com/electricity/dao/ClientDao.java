package com.electricity.dao;

import com.electricity.model.Client;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ClientDao {

    Client findById(Long id);

    List<Client> findAll();

    List<Client> findByType(@Param("clientType") String clientType);

    List<Client> findActive();

    int insert(Client client);

    int update(Client client);

    int deleteById(Long id);

    int countByAccountNumber(@Param("accountNumber") String accountNumber);
}
