//zad.2. 
clc;
clear;
lines(0);

MacierzWag = [ 0 0 0;
    0 0 1;
    0 1 0;
    0 1 1;
    1 0 0;
    1 0 1;
    1 1 0;
    1 1 1];
MacierzWektorowWzorcowych = 0;

MacierzNeuronow = [ 0  2 -1;
    2  0  1;
   -1  1  0];
Y=0;

function [wy]=unipolar(a)
    [row col]=size(a);
    if row*col<>1 then
        wy=zeros(row,col);
        for i = 1:row
            for j = 1:col
                wy(i,j) = unipolar(a(i,j));
            end;
        end
    else
        if a > 0 then
            wy=1;
        else
            wy=0;
        end        
    end
endfunction

function wy_log=isInMatrix(Y,X) // funkcja pomocnicza, sprawdza czy wektor X znajduje się już w macierzy Y
    
    if size(Y,'c') <> size(X,'c') | size(X,'r') <> 1 then
        printf('Niepoprawne dane wejściowe: wymiar kolumn dla obu macierzy nie jest zgodny lub macierz druga nie jest wektorem wierszowym.');
    end
    
    wy_log=%f;
    for i=1:size(Y,'r')
        if Y(i,:) == X then
            wy_log=%t
        end
    end
endfunction

function [wy]=bipolar(a)
    [row col]=size(a);
    if row*col<>1 then
        wy=zeros(row,col);
        for i = 1:row
            for j = 1:col
                wy(i,j) = bipolar(a(i,j));
            end;
        end
    else
        if a > 0 then
            wy=1;
        else
            wy=-1;
        end        
    end
endfunction

// podpunkt 4) projektu
JedynkaUnipolarna = [ 0 0 0 1 0;
                     0 0 1 1 0;
                     0 1 0 1 0;
                     1 0 0 1 0;
                     0 0 0 1 0;
                     0 0 0 1 0;
                     0 0 0 1 0];
                     
JedynkaBipolarna = [ -1 -1 -1 1 -1;
                     -1 -1 1 1 -1;
                     -1 1 -1 1 -1;
                     1 -1 -1 1 -1;
                     -1 -1 -1 1 -1;
                     -1 -1 -1 1 -1;
                     -1 -1 -1 1 -1];    
                     
testowyMacierz = [1 2 -4]; 
testowyMacierzWag = [-0,5 1 0,5];                                     
                    
function printC(macierzNeuronow)
    disp(macierzNeuronow);
endfunction

function wy=KonfiguracjazWagamiBezUczeniaSie(macierzWag, macierzNeuronow, funkcjaAktywacji)
    
endfunction

function wy=KonfiguracjazWagamiBezUczeniaSie(macierzWag, macierzNeuronow, funkcjaAktywacji)
          
    printf('=========== SYNCHRONICZNA SH ============== : \n');

Rozmiar=size(macierzNeuronow,'r');
printf('Rozmiar wejscia: %d\n',Rozmiar);

N=2^Rozmiar; // liczba wszystkiech możliwych wektorów na wejściu
printf('Liczba wektorow wejsciowych: %d\n',N);


printf('Tryb działania sieci: synchroniczny.\n');

printf('BADANIE ZBIEŻNOŚCI\n\n');

for j=1:N

    printf('BADANIE WEKTORA NR %d @@@@@@@@@@@@@@@@@@@@@',j);
    disp(MacierzWag(j,:));

    //inicjacja wartosci:
    Uk=zeros(Rozmiar,1);
    Vk=ones(Rozmiar,1);
    V=MacierzWag(j,:)';//=[0 1 1]';
    k=1;

    //badanie zbieżności:
    Vk_1=V;

    printf('\nWektor V(0):');
    disp(Vk_1');
    //petla
    warunek_stop=%f; // warunek stopu nie jest spełniony

    while ~warunek_stop,
        printf('KROK\t%d\n',k);
        printf('Potencjał wejsciowy U(%d) \n',k);
        Uk=MacierzNeuronow*Vk_1;
        disp(Uk');

        printf('Potencjał wyjsciowy V(%d) \n',k);
        
        if funkcjaAktywacji == 1 then
        else
            printf('Funkcja aktywacji: Bipolarny \n');
            Vk=bipolar(Uk);
        end
        
        if funkcjaAktywacji == -1 then
        else
            printf('Funkcja aktywacji: Unipolarny \n');
            Vk=unipolar(Uk);
        end      
        
        disp(Vk');
        k=k+1;
        if Vk_1 == Vk then
            warunek_stop=%t;
            printf('Zbieżny do:');
            disp(Vk');
            
            if size(Y,'c')==1 then
                Y=Vk';
            else
                if isInMatrix(Y,Vk')==%f then
                    Y=[Y; Vk'];
                end
            end  
        else
            Vk_1=Vk;
        end
        if k==16 then
            printf('BRAK ZBIEZNOSCI!!!!!\n');
            break;
        end
    end
wy=Y;
end


//    if(funkcjaAktywacji == 0) then
//        wy = macierzWag * macierzWektorowWzorcowych * funkcjaAktywacji;
//    else
//        wy = macierzWag * macierzWektorowWzorcowych * funkcjaAktywacji;
//    end 
       
endfunction

function wynik=synchronicznaSH(macierzWag,macierzWektorowWzorcowych,MacierzNeuronow,funkcjaAktywacji)
 
 // Podpunkt 2a) projektu   
 if macierzWektorowWzorcowych == -1 then
        printf('BRAK MACIERZÓW WZORCOWYCH \n');
        wynik=KonfiguracjazWagamiBezUczeniaSie(MacierzWag,MacierzNeuronow,funkcjaAktywacji);
    else
       printf('Z MACIERZAMI WZORCOWYMI \n');
    end
    
 // Podpunkt 2b) projektu
     if macierzWag == -1 then
        printf('SIEĆ NIE MA ZAPISANEJ WIEDZY W MACIERZY WAG \n');
        wynik=KonfiguracjaBezWiedzywWagach(MacierzWag,MacierzNeuronow,funkcjaAktywacji);
    else
       printf(' \n');
    end 
endfunction

// Funkcje które można uruchomić w ramach pracy nad projektem

//Z = synchronicznaSH(MacierzWag,MacierzWektorowWzorcowyc,MacierzNeuronow,1)
//Z = synchronicznaSH(MacierzWag,-1,MacierzNeuronow,-1);
//printC(JedynkaUnipolarna);
//printC(JedynkaBipolarna);
Z = synchronicznaSH(testowyMacierzWag,-1,testowyMacierz,1);
