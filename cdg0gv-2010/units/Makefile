#PC=	ppc386
PC=	ppcx64

CDGDIR=        ..
INCLDIR=        $(CDGDIR)/include
UNITDIR=        $(CDGDIR)/units
TOOLDIR=        $(CDGDIR)/tools

PFLAGS=		-So -Fu../units -I../include

%:		%.p 
		$(PC) $(PFLAGS)  $<
units:		
		$(PC) $(PFLAGS)  geograph.p 
		$(PC) $(PFLAGS)  hiddenl.p 
clean:
		rm -f *~ *.o *.ppu 



