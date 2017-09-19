#PC=	ppc386
PC=	ppcx64

CDGDIR=         ..
INCLDIR=        $(CDGDIR)/include
UNITDIR=        $(CDGDIR)/units
TOOLDIR=        $(CDGDIR)/tools

PFLAGS=		-So -Fu../units -I../include

%:		%.p
		$(PC) $(PFLAGS)  $<

units:		
		(cd $(UNITDIR) && make units)
		(cd $(TOOLDIR) && make tools)

clean:
		rm -f *~ *.o  

cleanall:
		rm -f *~ *.o n_eck 
		(cd $(TOOLDIR) && make clean)
		(cd $(UNITDIR) && make clean)



