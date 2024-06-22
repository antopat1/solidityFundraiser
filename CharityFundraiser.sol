// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Importa la libreria ReentrancyGuard
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CharityFundraiser is ReentrancyGuard {
    uint256 private totalBalance;
    address private manager;
    uint256 private goal;
    uint256 private totalDonors;
    bool private isFundraiserClosed;

    // Struttura per definire i partecipanti (manager o donatore)
    struct Participant {
        address addr; // Indirizzo del partecipante
        string name; // Nome del partecipante
        string role; // Ruolo del partecipante (manager o donatore)
        uint256 amountDonated; // Importo donato
        bool hasDonated; // Flag per indicare se ha donato
        bool exists; // Campo aggiunto per indicare se il partecipante esiste
    }

    // Mapping per tenere traccia dei partecipanti e delle donazioni
    mapping(address => Participant) private participants;

    // Array per tenere traccia degli indirizzi dei donatori
    address[] private donorAddresses;

    // Evento per notificare una donazione
    event DonationReceived(address indexed donor, uint256 amount);

    // Evento per notificare il prelievo dei fondi raccolti
    event FundsWithdrawn(address indexed manager, uint256 amount);

    // Evento per notificare la chiusura della raccolta fondi
    event FundraiserClosed();

    // Costruttore per impostare il manager e l'obiettivo della raccolta fondi in Ether
    constructor(uint256 _goalInEther, string memory _managerName) {
        require(bytes(_managerName).length > 0, "Il nome del manager deve essere specificato.");
        manager = msg.sender; // L'account che deploya il contratto è il manager
        goal = etherToWei(_goalInEther); // Convertiamo l'obiettivo da Ether a Wei
        participants[manager] = Participant(manager, _managerName, "manager", 0, false, true); // Crea il partecipante manager
    }

    // Modifier per limitare l'accesso alle funzioni solo al manager
    modifier onlyManager() {
        require(msg.sender == manager, "Solo il manager puo' eseguire questa funzione.");
        _;
    }

    // Funzione per convertire Ether in Wei
    function etherToWei(uint256 amountInEther) internal pure returns (uint256) {
        return amountInEther * 1 ether;
    }

    // Funzione per convertire Wei in Ether
    function weiToEther(uint256 amountInWei) internal pure returns (uint256) {
        return amountInWei / 1 ether;
    }

    // Funzione per donare Ether al contratto
    function donate(string memory donorName) public payable {
        require(!isFundraiserClosed, "La raccolta fondi e' chiusa.");
        require(msg.value > 0, "Devi donare una somma maggiore di 0.");
        require(!participants[msg.sender].exists, "Hai gia' effettuato una donazione.");
        require(totalBalance + msg.value <= goal, "La donazione supera l'obiettivo della raccolta fondi.");

        // Aggiorna il saldo totale raccolto
        totalBalance += msg.value;

        // Aggiorna il numero totale di donatori e il mapping dei partecipanti
        participants[msg.sender] = Participant(msg.sender, donorName, "donor", msg.value, true, true);
        totalDonors++;
        donorAddresses.push(msg.sender); // Aggiunge l'indirizzo all'array

        // Emissione dell'evento di donazione
        emit DonationReceived(msg.sender, msg.value);
    }

    // Funzione per il manager per prelevare gli Ether raccolti
    function withdrawFunds() public onlyManager nonReentrant {
        require(isFundraiserClosed, "La raccolta fondi deve essere chiusa prima di poter prelevare i fondi.");
        require(address(this).balance > 0, "Nessun fondo disponibile per il prelievo.");

        uint256 amount = address(this).balance;
        totalBalance = 0;

        // Trasferisce tutti i fondi al manager
        (bool success, ) = manager.call{value: amount}("");
        require(success, "Trasferimento dei fondi fallito.");

        // Emissione dell'evento di prelievo
        emit FundsWithdrawn(manager, amount);
    }

    // Funzione per chiudere la raccolta fondi
    function closeFundraiser() public onlyManager {
        require(!isFundraiserClosed, "La raccolta fondi e' gia' chiusa.");

        // Chiude la raccolta fondi
        isFundraiserClosed = true;

        // Emissione dell'evento di chiusura
        emit FundraiserClosed();
    }

    // Funzione per controllare se l'obiettivo è stato raggiunto o superato
    function checkGoalReached() public view returns (bool) {
        return totalBalance >= goal;
    }

    // Funzione per ottenere l'obiettivo in Ether
    function getGoalInEther() public view returns (uint256) {
        return weiToEther(goal);
    }

    // Funzione per ottenere il saldo totale raccolto in Ether
    function getTotalBalanceInEther() public view returns (uint256) {
        return weiToEther(totalBalance);
    }

    // Funzione per ottenere il numero totale di donatori
    function getTotalDonors() public view returns (uint256) {
        return totalDonors;
    }

    // Funzione per ottenere lo stato della raccolta fondi
    function getFundraiserStatus() public view returns (bool) {
        return isFundraiserClosed;
    }

    // Funzione per ottenere le informazioni di un partecipante
    function getParticipant(address participantAddress) public view returns (string memory, Participant memory) {
        if (!participants[participantAddress].exists) {
            return (string(abi.encodePacked("Al momento nessun utente ha partecipato alla raccolta organizzata e gestita dal manager: ", participants[manager].name)), Participant(address(0), "", "", 0, false, false));
        }
        return ("", participants[participantAddress]);
    }

    // Funzione per ottenere l'elenco degli indirizzi dei donatori
    function getDonors() public view returns (address[] memory) {
        return donorAddresses;
    }

    // Funzione per ottenere il mapping dei donatori e le loro donazioni
    function getDonations() public view returns (Participant[] memory) {
        if (donorAddresses.length == 0) {
            revert(string(abi.encodePacked("Al momento nessun utente ha partecipato alla raccolta organizzata e gestita dal manager: ", participants[manager].name)));
        }

        Participant[] memory donations = new Participant[](donorAddresses.length);
        for (uint i = 0; i < donorAddresses.length; i++) {
            donations[i] = participants[donorAddresses[i]];
        }
        return donations;
    }

    // Funzione per ottenere il nome del manager
    function getManagerName() public view returns (string memory) {
        return participants[manager].name;
    }
}
