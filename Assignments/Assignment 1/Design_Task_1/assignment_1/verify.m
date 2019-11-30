function verify(Ac, Bc, Cc, Dc, A, B)

    load('verify.mat')
    
    Ae  = Ac - Atrue;
    Be  = Bc - Btrue;
    Ce  = Cc - Ctrue;
    De  = Dc - Dtrue;
    Ade = A - Adtrue;
    Bde = B - Bdtrue;
    
    if (sqrt(trace(Ae'*Ae)) > 1e-3) || (norm(Be) > 1e-3) || (norm(Ce) > 1e-3) || (abs(De) > 1e-3)
        error('Incorrect parameters for discrete system dynamics')
    end

    if (sqrt(trace(Ade'*Ade)) > 1e-3) || ( norm(Bde) > 1e-3)
        error('Incorrect parameters for discrete system dynamics')
    end
    disp('Parameter values are correct!')
end
