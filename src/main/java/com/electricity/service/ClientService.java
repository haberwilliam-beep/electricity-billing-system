package com.electricity.service;

import com.electricity.dao.ClientDao;
import com.electricity.model.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class ClientService {

    private final ClientDao clientDao;

    @Autowired
    public ClientService(ClientDao clientDao) {
        this.clientDao = clientDao;
    }

    public Client findById(Long id) {
        return clientDao.findById(id);
    }

    public List<Client> findAll() {
        return clientDao.findAll();
    }

    public List<Client> findByType(String clientType) {
        return clientDao.findByType(clientType);
    }

    public List<Client> findActive() {
        return clientDao.findActive();
    }

    public void createClient(Client client) {
        if (client.getAccountNumber() == null || client.getAccountNumber().isEmpty()) {
            client.setAccountNumber(generateAccountNumber());
        }
        client.setActive(true);
        clientDao.insert(client);
    }

    public void updateClient(Client client) {
        clientDao.update(client);
    }

    public void deleteClient(Long id) {
        clientDao.deleteById(id);
    }

    private String generateAccountNumber() {
        return "ACC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
